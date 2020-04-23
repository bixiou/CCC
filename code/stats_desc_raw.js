$(document).ready(function($) {
    $.ajax({
        url:'stats_desc_raw.csv', 
        success: function(data){
            var stats_desc = charge(data);
            for (var i = 0; i<(stats_desc.length-1); i++) {
                $('#stats_desc').append('<p><br><span id="e_'+stats_desc[i][0]+'"></span><span class="var_def" id="'+stats_desc[i][0]+'" style="color:blue">Q$'+stats_desc[i][1]+'</span><br><span class="code restr">'+stats_desc[i][2]+'<br></span>');
            }
        },
        error: function(){ alert('Les données pe n\'ont pas pu être chargées');}
    });

    function charge(data) {
        var tab=data.split('\n');
        var n = tab.length;
        var stats = new Array(n);
        for (var i = 0; i<n; i++) { 
            stats[i] = tab[i].split(';;;');             
        }
        return stats
    }
});