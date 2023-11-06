import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

public class Test {

    public static void main(String[] args) throws IOException {

        String alg = args[0];
        String p = args[1];
        String path = args[2];

        String file = Files.readString(Path.of(path), StandardCharsets.UTF_8);
        String file2 = Files.readString(Path.of(p), StandardCharsets.UTF_8);

        Set<Character> Alphabet = Main.findAlphabet(file);

        char apo = '\'';
        StringBuilder pattern;
        Set<String> patterns = new HashSet<>();

        for(int i = 0; i < file2.length()-2; i++){
            if(file2.charAt(i) == apo){
                pattern = new StringBuilder();
                while(file2.charAt(i+1) != apo && i < file2.length()-2){
                    pattern.append(file2.charAt(i + 1));
                    i++;
                }
                patterns.add(String.valueOf(pattern));
                i++;
            }
        }


        for(String pat: patterns){
            System.out.println(pat+":");
            if(Objects.equals(alg, "kmp")){
                Main.kmpMatcher(file, pat);
            } else {
                Main.finiteAutomatonMatcher(file, Main.computeTransitionFunction(pat, Alphabet), pat.length());
            }
            System.out.println("------------");
        }

    }
}
