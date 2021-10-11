int fib_array[11];

void main () {
    int i;
    for (i = 0; i < 11; i++) {
        fib_array[i] = fib_rec(i);
    }
}

int fib_rec (int a) {
    if (a <= 1)
        return a;
    else
        return fib_rec(a-1) + fib_rec(a-2);
}
