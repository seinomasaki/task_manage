// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require activestorage
//= require turbolinks
//= require toastr
//= require chartkick
//= require_tree .
//= require vue
//= require vue-resource


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
                    url: '/admin/summaries/calendar.json',
                    data:{
                        time_limit: (year+'-'+month+'-'+day),
                    },
                }).done(function (response) {
                    var select_tasks = [];
                    for ( let i = 0; i < response.length; i++ ) {
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
        }
    })
};