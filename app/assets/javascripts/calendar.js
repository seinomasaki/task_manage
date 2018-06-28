window.onload = function() {
    new Vue({
        el: '#calendar-tasks',
        data: {
            year: ' ',
            month: ' ',
            day: ' ',
            select_tasks: [],
        },
        methods: {
            showTasks: function(year,month,day) {
                var self = this;
                $.ajax({
                    type: 'GET',
                    url: 'calendar.json',
                    data:{
                        datetime: (year+'-'+month+'-'+day),
                        time_limit: (year+'-'+month+'-'+day),
                    },
                }).done(function (response) {
                    var select_tasks = [];
                    for ( var i = 0; i < response.length; i++ ) {
                        select_tasks.push(response[i]);
                    }
                    self.select_tasks = select_tasks;
                    self.year = year;
                    self.month = month;
                    self.day = day;
                }).fail(function (response) {
                    // 処理が失敗した時の処理
                    alert ("fail: #{response}")
                });
            },
            showTask: function (task_path) {
                window.location.href = task_path
            }
        }
    })
};