$(document).ready(function() {
                  var language = window.navigator.userLanguage || window.navigator.language;
                  if (language.indexOf("en-")==0){
                    language = "en";
                  }
                  $.getScript("sys."+language+".js");
                  });