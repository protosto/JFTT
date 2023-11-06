import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

public class Main {


    static Set<Character> findAlphabet(String text){
        Set<Character> Alphabet = new HashSet<>();
        for( char a: text.toCharArray() ){
            Alphabet.add(a);
        }
        return Alphabet;
    }

    static Map<Pair, Integer> computeTransitionFunction(String Pattern, Set<Character> Alphabet) {

        int m = Pattern.length();
        Map<Pair, Integer> del = new HashMap<>();
        int x;

        for (int i = 0; i <= m; i++) {
            for (char a: Alphabet) {

                x = Math.min(m+1, i+2);

                do{ x--; } while( !(Pattern.substring(0, i)+a).endsWith(Pattern.substring(0, x)));
                del.put(new Pair(i, a), x);
            }
        }
        return del;
    }

    static void finiteAutomatonMatcher(String text, Map<Pair, Integer> del, int Patternlen){
        int n = text.length();
        int q = 0;

        for(int i = 0; i < n; i++){
            q = del.get(new Pair(q, text.charAt(i)));
            if(q == Patternlen) System.out.println(" " +text.codePointCount(0,i-Patternlen+1));
        }
    }


    static Map<Integer, Integer> computePrefixFunction (String Pattern){
        int m = Pattern.length();
        Map<Integer, Integer> pi = new HashMap<>();
        pi.put(1,0);
        int k = 0;

        for(int i = 2; i <= m; i++){
           while( k > 0 && Pattern.charAt(k) != Pattern.charAt(i-1) ){
               k = pi.get(k);
           }

           if(Pattern.charAt(k) == Pattern.charAt(i-1)) k++;
           pi.put(i, k);
        }

        return pi;
    }

    static void kmpMatcher(String text, String Pattern){
        int n = text.length();
        int m = Pattern.length();
        Map<Integer, Integer> pi = computePrefixFunction(Pattern);
        int q = 0;

        for(int i = 0; i < n; i++){

            while(q > 0 && Pattern.charAt(q) != text.charAt(i)){
                q = pi.get(q);
            }

            if(Pattern.charAt(q) == text.charAt(i)) q++;

            if(q == m) {
                System.out.println(" " + text.codePointCount(0, i - m + 1));
                q = pi.get(q);
                }
            }
        }


    public static void main(String[] args) throws IOException {

        String p = args[0];
        String path = args[1];

        String file = Files.readString(Path.of(path));
        Set<Character> Alphabet = findAlphabet(file);


        finiteAutomatonMatcher(file, computeTransitionFunction(p, Alphabet), args[0].length());
        kmpMatcher(file, p);

    }
}