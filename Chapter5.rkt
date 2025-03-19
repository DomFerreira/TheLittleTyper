#lang pie

;; Question 1
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

;; Question 2
;; Define a function called maybe-last which takes (in addition to the type argument for the list element)
;; one (List E) argument and one E argument and evaluates to an E with value of either the last element in the list,
;; or the value of the second argument if the list is empty.

;; SOLUTION:
;; Define maybe-Last that returns the last element of a List or a default if empty.
(claim step-Last
  (Pi ((E U))
    (-> E (List E) E E)))

(define step-Last
  (lambda (E)
  (lambda (e es last)
    (rec-List es
      e ; Base case: return current element if rest of list is empty
      (lambda (e_ es_ last_)
        last))))) ; Recursive case: continue with the last element found so far

(claim maybe-Last
  (Pi ((E U))
    (-> (List E) E E)))

;; maybe-Last returns last element or provided default if empty.
(define maybe-Last
  (lambda (E)
    (lambda (es default)
      (rec-List es
        default ; Base case: return default if list is empty
        (step-Last E))))) ; Recursive case: use step-Last

;; Question 3
;; Define a function called filter-list which takes (in addition to the type argument for the list element)
;; one (-> E Nat) argument representing a predicate and one (List E) argument.
;; The function evaluates to a (List E) consisting of elements from the list argument where the predicate is true.
;; Consider the predicate to be false for an element if it evaluates to zero, and true otherwise.

;; SOLUTION:
;; Define filter-list which filters a list by a predicate (E -> Nat), where zero means false and non-zero true.
(claim step-filter
  (Pi ((E U))
    (-> (-> E Nat) E (List E) (List E) (List E))))

;; Step function for filter, adding elements where predicate is true.
(define step-filter
  (lambda (E)
    (lambda (pred h _ filtered)
      (rec-Nat (pred h)
        filtered ; If predicate is false (zero), skip element
        (lambda (n-1 _) ; If predicate is true (non-zero), include element
          (:: h filtered))))))

(claim filter-list
  (Pi ((E U))
    (-> (-> E Nat) (List E) (List E))))

;; filter-list filters a list by a predicate.
(define filter-list
  (lambda (E)
    (lambda (pred es)
      (rec-List es
        (the (List E) nil) ; Base case: empty filtered list
        (step-filter E pred))))) ; Recursive case: use step-filter

(claim not
  (-> Nat Nat))

;; Logical NOT function for Nats (0 becomes 1, non-zero becomes 0).
(define not
  (lambda (n)
    (rec-Nat n
      1 ; Base case: 0 becomes 1
      (lambda (n-1 notzero)
        0)))) ; Recursive case: non-zero becomes 0

(claim id
  (-> Nat Nat))

(define id
  (lambda (n) n)) ; Returns input unchanged

;; Question 4
;; Define a function called sort-List-Nat which takes one (List Nat) argument and evaluates
;; to a (List Nat) consisting of the elements from the list argument sorted in ascending order.

;; SOLUTION:
;; Define sort-List-Nat which sorts a List Nat in ascending order.
(claim <
  (-> Nat Nat Nat))

;; Comparison function returning 1 if x < y, otherwise 0.
(define <
  (lambda (x)
    (rec-Nat x
      (the (-> Nat Nat) (lambda (_) 1)) ; Base case: 0 is always less than any positive number
      (lambda (x-1 res)
        (lambda (y)
          (rec-Nat y
            0 ; Base case: any number is not less than 0
            (lambda (y-1 _)
              (res y-1)))))))) ; Recursive case: check next smaller pair

(claim insert
  (-> (List Nat) Nat (List Nat)))

;; Function to insert a number into a sorted list.
(define insert
  (lambda (list)
    (rec-List list
    (the (-> Nat (List Nat)) (lambda (i)
      (:: i nil) ; Base case: insert into empty list
      ))
    (lambda (e es insertInto)
      (lambda (i)
        (which-Nat (< i e)
          (:: e (insertInto i)) ; Recursive case: keep e before i
          (lambda (_) (:: i (insertInto e))))))))) ; Recursive case: insert i before e

(claim sort
  (-> (List Nat) (List Nat)))

;; Function to sort a list using insertion sort.
(define sort
  (lambda (ls)
  (rec-List ls
    (the (List Nat) nil) ; Base case: empty list is already sorted
    (lambda (e es res)
      (insert res e))))) ; Recursive case: insert element into sorted list