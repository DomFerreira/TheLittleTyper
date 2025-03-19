#lang pie

;; Question 1
;; Extend the definitions of kar and kdr (frame 4.42) so they work with arbitrary Pairs
;; (instead of just for Pair Nat Nat).

;; SOLUTION:
;; The following is a claim that elim-Pair is a general eliminator for pairs.
;; It takes types A, D, X, a pair of type (Pair A D), and a function from A and D to X,
;; and returns a value of type X.
(claim elim-Pair
  (Pi ((A U) (D U) (X U))
    (-> (Pair A D) (-> A D X) X)))

(define elim-Pair
  (lambda (A D X)
    (lambda (p f)
      (f (car p) (cdr p)))))

;; kar retrieves the first element (car) of a pair.
(claim kar
  (Pi ((A U) (D U))
    (-> (Pair A D) A)))

(define kar
  (lambda (A D)
    (lambda (p)
      (elim-Pair
        A D ; Types for elements of the pair
        A ; Result type is the type of the first element (car)
        p ; The pair from which we take the first element
        (lambda (a d)
          a))))) ; Returns the first element (car)

;; kdr retrieves the second element (cdr) of a pair.
(claim kdr
  (Pi ((A U) (D U))
    (-> (Pair A D) D)))

(define kdr
  (lambda (A D)
    (lambda (p)
      (elim-Pair
        A D ; Types for elements of the pair
        D ; Result type is the type of the second element (cdr)
        p ; The pair from which we take the second element
        (lambda (a d)
          d))))) ; Returns the second element (cdr)


;; Question 2
;; Define a function called compose that takes (in addition to the type arguments A, B, C)
;; an argument of type (-> A B) and an argument of type (-> B C) that
;; and evaluates to a value of type (-> A C), the function composition of the arguments.

;; SOLUTION:
;; compose takes two functions: (-> A B) and (-> B C) and produces a function (-> A C).
(claim compose
  (Pi ((A U) (B U) (C U))
    (-> (-> A B) (-> B C) (-> A C))))

(define compose
  (lambda (A B C)
    (lambda (f g)
      (lambda (a)
        (g (f a)))))) ; Applies f first, then g to the result

;; Define a function to check if a Nat number is zero or not.
(claim isZero
  (-> Nat Atom))

(define isZero
  (lambda (n)
    (rec-Nat n
      'zero ; Base case: when n is zero, return 'zero
      (lambda (n-1 notzero)
        'notzero)))) ; Recursive case: if not zero, return 'notzero

;; match creates a Pair Atom Atom from an Atom.
(claim match
  (-> Atom (Pair Atom Atom)))

;; Creates a pair from the same atom twice.
(define match
  (lambda (a)
    (cons a a))) ; Creates pair (a, a)

;; double is a composition of isZero and match.
;; It takes a Nat, checks if it is zero ('zero or 'notzero), and makes a pair out of it.
(claim double
  (-> Nat (Pair Atom Atom)))

(define double
  (compose Nat Atom (Pair Atom Atom) isZero match)) ; Composes isZero and match