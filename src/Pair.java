import java.util.Objects;

public class Pair {

    int first;
    char second;

    public Pair(int a, char b){
        this.first = a;
        this.second = b;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Pair pair = (Pair) o;
        return first == pair.first && second == pair.second;
    }

    @Override
    public int hashCode() {
        return Objects.hash(first, second);
    }
}
