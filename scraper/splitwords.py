# Import the AudioSegment class for processing audio and the 
# split_on_silence function for separating out silent chunks.
from pydub import AudioSegment
from pydub.silence import split_on_silence

# Define a function to normalize a chunk to a target amplitude.
def match_target_amplitude(aChunk, target_dBFS):
    ''' Normalize given audio chunk '''
    change_in_dBFS = target_dBFS - aChunk.dBFS
    return aChunk.apply_gain(change_in_dBFS)

#get list of ogg files in the ogg subdirectory
import os
ogg_files = [f for f in os.listdir('ogg') if f.endswith('.ogg')]
#strip extensions from file names in ogg_files
ogg_files = [f[:-4] for f in ogg_files]

print(ogg_files)

#for each ogg_file
for ogg_file in ogg_files:
    # Load your audio.
    song = AudioSegment.from_ogg(r"./ogg/"+ogg_file+".ogg")

    song = match_target_amplitude(song, -20.0)
    
    #print song length in seconds
    print(song.duration_seconds)
    
    base_thresh = -40
    thresh=base_thresh
    chunks=[0,0,0]
    while(len(chunks)>2 and thresh<0):
        # Split track where the silence is 2 seconds or more and get chunks using 
        # the imported function.
        chunks = split_on_silence (
            # Use the loaded audio.
            song, 
            # Specify that a silent chunk must be at least 2 seconds or 2000 ms long.
            min_silence_len = 150,
            # Consider a chunk silent if it's quieter than -16 dBFS.
            # (You may want to adjust this parameter.)
            silence_thresh = thresh
        )
        if (len(chunks)>2):
            print("thresh: "+str(thresh))
            print("chunks: "+str(len(chunks)))
            thresh = thresh + 5
            if thresh>=0:
                print("gave up")
                chunks = split_on_silence (
                    # Use the loaded audio.
                    song, 
                    # Specify that a silent chunk must be at least 2 seconds or 2000 ms long.
                    min_silence_len = 200,
                    # Consider a chunk silent if it's quieter than -16 dBFS.
                    # (You may want to adjust this parameter.)
                    silence_thresh = base_thresh
                )
                break



    print(chunks)

    # Process each chunk with your parameters
    for i, chunk in enumerate(chunks):
        print("writing " + str(i) + ": " + str(len(chunk)) + " ms")
        # Create a silence chunk that's 0.5 seconds (or 500 ms) long for padding.
        # silence_chunk = AudioSegment.silent(duration=500)

        # Add the padding chunk to beginning and end of the entire chunk.
        # audio_chunk = silence_chunk + chunk + silence_chunk
        audio_chunk = chunk
        # Normalize the entire chunk.
        normalized_chunk = match_target_amplitude(audio_chunk, -20.0)
        #print normalized_chunk length
        print("duration" + str(normalized_chunk.duration_seconds))

        # Export the audio chunk with new bitrate.
        fname = r"./ogg/splits/"+ogg_file+"_"+str(i)+".mp3"
        print("Exporting {0}".format(fname))
        normalized_chunk.export(
            fname,
            bitrate = "192k",
            format = "mp3"
        )


        # broken Voiced_alveolar_affricate_0
        # Voiced_alveolar_lateral_fricative_0.mp3
        # Voiced_retroflex_affricate_0.mp3
        # Voiceless_alveolar_lateral_fricative_0.mp3
        # Voiceless_alveolo-palatal_affricate_0.mp3