function run_haos_open_house(array_of_directories_to_offer) {
    for (var i = 0; i < array_of_directories_to_offer.length; i++) {
        console.log("array_of_directories_to_offer[" + i + "][0] = " + array_of_directories_to_offer[i][0]);
        console.log("array_of_directories_to_offer[" + i + "][1] = " + array_of_directories_to_offer[i][1]);
        run_ajax_open_haos_thingy(array_of_directories_to_offer[i][0], array_of_directories_to_offer[i][1]);
    }
}

function run_ajax_open_haos_thingy(folder_location, regex_string) {
    $.ajax({
        url: folder_location,
        success: function(data) {
            console.log("data = " + data);
            $(data).find("a").attr("href", function(i, val) {
                if (val.match(regex_string)) {
                    $("body").append("<a href='" + folder_location + val + "'>" + val.replace(/\.[^/.]+$/, "") + "</a></br>");
                }
            });
        }
    });
}

var image_folder = "img/"
var pages_folder = "pgs/"

var image_regex = new RegExp(".(jpe?g|png|gif)");
var pages_regex = new RegExp(".(html)")

var open_haos_folders = [
    [image_folder, image_regex],
    [pages_folder, pages_regex]
];

run_haos_open_house(open_haos_folders);