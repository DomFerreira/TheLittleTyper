#lang pie

;; CHAPTER 4:
;; Q2
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

;; CHAPTER 5:
;; Q1
;; Define a function called sum-List that takes one List Nat argument
;; and evaluates to a Nat, the sum of the Nats in the list.

;; SOLUTION:
(claim +
  (-> Nat Nat Nat))

(define +
  (lambda (i j)
    (rec-Nat j
      i ; Base case: if second number is 0, return first number
      (lambda (j-1 sum-j-1)
        (add1 sum-j-1))))) ; Recursive case: increment the sum

;; Step function used for summing list elements.
(claim step-sum
  (-> Nat (List Nat) Nat Nat))

(define step-sum
  (lambda (e es sum)
    (+ e sum))) ; Add current element to accumulated sum

;; Function sum-List uses list recursion to calculate sum.
(claim sum-List
  (-> (List Nat) Nat))

(define sum-List
  (lambda (es)
    (rec-List es
      0 ; Base case: empty list sum is 0
      step-sum))) ; Recursive case: sum elements using step-sum