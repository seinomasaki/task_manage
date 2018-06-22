server '54.65.75.229',
       user: 'masaki',
       roles: %w[app db web]

set :ssh_options,
    port: 22,
    keys: %w[~/.ssh/masaki_aws_rsa],
    forward_agent: true,
    auth_methods: %w[publickey]
