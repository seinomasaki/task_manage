RSpec.shared_examples_for :backend do
  def uploadable(data = "hello")
    Refile::FileDouble.new(data)
  end

  def open_files
    ObjectSpace.each_object(File).reject { |f| f.closed? } if defined?(ObjectSpace)
  end

  describe "#upload" do
    it "raises ArgumentError when invalid object is uploaded" do
      expect { backend.upload(double(size: 123)) }.to raise_error(ArgumentError)
      expect { backend.upload("hello") }.to raise_error(ArgumentError)
    end

    it "raises Refile::Invalid when object is too large" do
      expect { backend.upload(uploadable("a" * 200)) }.to raise_error(Refile::Invalid)
    end

    it "stores file for later retrieval" do
      file = backend.upload(uploadable)
      retrieved = backend.get(file.id)

      expect(retrieved.read).to eq("hello")
      expect(retrieved.size).to eq(5)
      expect(retrieved.exists?).to be_truthy
    end

    it "can store an uploaded file" do
      file = backend.upload(uploadable)
      file2 = backend.upload(file)

      retrieved = backend.get(file2.id)

      expect(retrieved.read).to eq("hello")
      expect(retrieved.size).to eq(5)
      expect(retrieved.exists?).to be_truthy
    end
  end

  describe "#delete" do
    it "removes a stored file" do
      file = backend.upload(uploadable)

      backend.delete(file.id)

      expect(backend.get(file.id).exists?).to be_falsy
    end

    it "does not affect other files" do
      file = backend.upload(uploadable)
      other = backend.upload(uploadable)

      backend.delete(file.id)

      expect(backend.get(file.id).exists?).to be_falsy
      expect(backend.get(other.id).exists?).to be_truthy
    end

    it "does nothing when file doesn't exist" do
      file = backend.upload(uploadable)

      backend.delete(file.id)
      backend.delete(file.id)
    end

    it "can be called through file" do
      file = backend.upload(uploadable)

      file.delete

      expect(backend.get(file.id).exists?).to be_falsy
    end
  end

  describe "#read" do
    it "returns file contents" do
      file = backend.upload(uploadable)
      expect(backend.read(file.id)).to eq("hello")
    end

    it "returns nil when file doesn't exist" do
      expect(backend.read("nosuchfile")).to be_nil
    end

    it "can be called through file" do
      file = backend.upload(uploadable)
      expect(file.read).to eq("hello")
    end
  end

  describe "#size" do
    it "returns file size" do
      file = backend.upload(uploadable)
      expect(backend.size(file.id)).to eq(5)
    end

    it "returns nil when file doesn't exist" do
      expect(backend.size("nosuchfile")).to be_nil
    end

    it "can be called through file" do
      file = backend.upload(uploadable)
      expect(file.size).to eq(5)
    end
  end

  describe "#exists?" do
    it "returns true when file exists" do
      file = backend.upload(uploadable)
      expect(backend.exists?(file.id)).to eq(true)
    end

    it "returns false when file doesn't exist" do
      expect(backend.exists?("nosuchfile")).to eq(false)
    end

    it "can be called through file" do
      expect(backend.upload(uploadable).exists?).to eq(true)
      expect(backend.get("nosuchfile").exists?).to eq(false)
    end
  end

  describe "#clear!" do
    it "removes files when called with :confirm" do
      file = backend.upload(uploadable)

      backend.clear!(:confirm)

      expect(backend.get(file.id).exists?).to be_falsy
    end

    it "complains when called without confirm" do
      file = backend.upload(uploadable)

      expect { backend.clear! }.to raise_error(ArgumentError)

      expect(backend.get(file.id).exists?).to be_truthy
    end
  end

  describe "File" do
    it "is an io-like object" do
      before = open_files

      file = backend.upload(uploadable)

      buffer = ""
      result = ""

      until file.eof?
        chunk = file.read(2, buffer)
        result << chunk
        expect("hello").to include(buffer)
      end

      expect(result).to eq("hello")

      file.close

      expect { file.read(1, buffer) }.to raise_error

      expect(open_files).to eq(before)
    end

    describe "#read" do
      it "can read file contents" do
        file = backend.upload(uploadable)

        buffer = ""

        expect(file.read).to eq("hello")
      end

      it "can read entire file contents into buffer" do
        file = backend.upload(uploadable)

        buffer = ""

        file.read(nil, buffer)

        expect(buffer).to eq("hello")
      end
    end

    describe "#each" do
      it "can read file contents" do
        file = backend.upload(uploadable)

        buffer = ""
        file.each do |chunk|
          buffer << chunk
        end

        expect(buffer).to eq("hello")
      end

      it "returns an enumerator when no block given" do
        file = backend.upload(uploadable)

        expect(file.each.to_a.join).to eq("hello")
      end
    end

    describe "#download" do
      it "returns a downloaded tempfile" do
        file = backend.upload(uploadable)
        download = file.download

        expect(download).to be_an_instance_of(Tempfile)
        expect(File.read(download.path)).to eq("hello")
      end
    end
  end
end
