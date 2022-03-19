var oggFiles = ["Close_front_rounded_vowel.ogg",
"Close_central_rounded_vowel.ogg",
"Close_back_rounded_vowel.ogg",
"Near-close_near-front_rounded_vowel.ogg",
"Near-close_near-back_rounded_vowel.ogg",
"Close-mid_front_rounded_vowel.ogg",
"Close-mid_central_rounded_vowel.ogg",
"Close-mid_back_rounded_vowel.ogg",
"Mid-central_vowel.ogg",
"Open-mid_front_rounded_vowel.ogg",
"Open-mid_central_rounded_vowel.ogg",
"Open-mid_back_rounded_vowel.ogg",
"Near-open_front_unrounded_vowel.ogg",
"Near-open_central_unrounded_vowel.ogg",
"Open_front_rounded_vowel.ogg",
"Open_back_rounded_vowel.ogg",
"Voiceless_bilabial_plosive.ogg",
"Voiced_bilabial_plosive.ogg",
"Voiceless_alveolar_plosive.ogg",
"Voiced_alveolar_plosive.ogg",
"Voiceless_retroflex_plosive.ogg",
"Voiced_retroflex_plosive.ogg",
"Voiceless_palatal_plosive.ogg",
"Voiced_palatal_plosive.ogg",
"Voiceless_velar_plosive.ogg",
"Voiced_velar_plosive.ogg",
"Voiceless_uvular_plosive.ogg",
"Voiced_uvular_plosive.ogg",
"Glottal_stop.ogg",
"Bilabial_nasal.ogg",
"Labiodental_nasal.ogg",
"Alveolar_nasal.ogg",
"Retroflex_nasal.ogg",
"Palatal_nasal.ogg",
"Velar_nasal.ogg",
"Uvular_nasal.ogg",
"Bilabial_trill.ogg",
"Alveolar_trill.ogg",
"Uvular_trill.ogg",
"Labiodental_flap.ogg",
"Alveolar_tap.ogg",
"Retroflex_flap.ogg",
"Voiceless_bilabial_fricative.ogg",
"Voiced_bilabial_fricative.ogg",
"Voiceless_labiodental_fricative.ogg",
"Voiced_labiodental_fricative.ogg",
"Voiceless_dental_fricative.ogg",
"Voiced_dental_fricative.ogg",
"Voiceless_alveolar_fricative.ogg",
"Voiced_alveolar_fricative.ogg",
"Voiceless_postalveolar_fricative.ogg",
"Voiced_postalveolar_fricative.ogg",
"Voiceless_retroflex_fricative.ogg",
"Voiced_retroflex_fricative.ogg",
"Voiceless_palatal_fricative.ogg",
"Voiced_palatal_fricative.ogg",
"Voiceless_velar_fricative.ogg",
"Voiced_velar_fricative.ogg",
"Voiceless_uvular_fricative.ogg",
"Voiced_uvular_fricative.ogg",
"Voiceless_pharyngeal_fricative.ogg",
"Voiced_pharyngeal_fricative.ogg",
"Voiceless_glottal_fricative.ogg",
"Voiced_glottal_fricative.ogg",
"Voiceless_alveolar_lateral_fricative.ogg",
"Voiced_alveolar_lateral_fricative.ogg",
"Labiodental_approximant.ogg",
"Alveolar_approximant.ogg",
"Retroflex_approximant.ogg",
"Palatal_approximant.ogg",
"Voiced_velar_approximant.ogg",
"Alveolar_lateral_approximant.ogg",
"Retroflex_lateral_approximant.ogg",
"Palatal_lateral_approximant.ogg",
"Velar_lateral_approximant.ogg",
"Bilabial_ejective_plosive.ogg",
"Alveolar_ejective_plosive.ogg",
"Velar_ejective_plosive.ogg",
"Alveolar_ejective_fricative.ogg",
"Voiced_uvular_implosive.ogg",
"Voiceless_labio-velar_fricative.ogg",
"Voiced_labio-velar_approximant.ogg",
"Labial-palatal_approximant.ogg",
"Voiceless_epiglottal_fricative.ogg",
"Voiced_epiglottal_fricative.ogg",
"Voiceless_epiglottal_plosive.ogg",
"Voiceless_alveolo-palatal_fricative.ogg",
"Voiced_alveolo-palatal_fricative.ogg",
"Alveolar_lateral_flap.ogg",
"Voiceless_dorso-palatal_velar_fricative.ogg",
"Voiceless_alveolar_affricate.ogg",
"Voiceless_palato-alveolar_affricate.ogg",
"Voiceless_alveolo-palatal_affricate.ogg",
"Voiceless_retroflex_affricate.ogg",
"Voiced_alveolar_affricate.ogg",
"Voiced_postalveolar_affricate.ogg",
"Voiced_alveolo-palatal_affricate.ogg",
"Voiced_retroflex_affricate.ogg"];

//download function
const https = require('https'); // or 'https' for https:// URLs
const fs = require('fs');

function downFile(url,localname){
  // if localname exists, delte
  if(fs.existsSync(localname)){
    fs.unlinkSync(localname);
  }

  const file = fs.createWriteStream(localname);
  const request = https.get(url, function(response) {
    response.pipe(file);
  });
}



(async function (){
//download all files to ogg directory
for (var i = 0; i < oggFiles.length; i++) {
    var file = oggFiles[i];
    var fileName = file.substring(file.lastIndexOf("/") + 1);
    var filePath = "./ogg/" + fileName;
    var url= "https://www.ipachart.com/ogg/" + fileName;
    console.log("Downloading "+url+" - " + file);
    downFile(url, filePath, function() {
    });
    //wait a half second
    await new Promise(r => setTimeout(r, 1000));
}
})();