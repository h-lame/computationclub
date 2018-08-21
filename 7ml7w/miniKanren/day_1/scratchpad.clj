(db-rel man⁰ x)
(db-rel woman⁰ x)

(def facts
  (db
    [man⁰ :alan-turing]
    [woman⁰ :grace-hopper]
    [man⁰ :leslie-lamport]
    [man⁰ :alonzo-church]
    [woman⁰ :ada-lovelace]
    [woman⁰ :barbara-liskov]
    [woman⁰ :frances-allen]
    [man⁰ :john-mccarthy]))

(db-rel vital⁰ p s)

(db-rel turing⁰ p y)


(def facts
  (-> facts
    (db-fact vital⁰ :alan-turing :dead)
    (db-fact vital⁰ :grace-hopper :dead)
    (db-fact vital⁰ :leslie-lamport :alive)
    (db-fact vital⁰ :alonzo-church :dead)
    (db-fact vital⁰ :ada-lovelace :dead)
    (db-fact vital⁰ :barbara-liskov :alive)
    (db-fact vital⁰ :frances-allen :alive)
    (db-fact vital⁰ :john-mccarthy :dead)
    (db-fact turing⁰ :leslie-lamport :2013)
    (db-fact turing⁰ :barbara-liskov :2008)
    (db-fact turing⁰ :frances-allen :2006)
    (db-fact turing⁰ :john-mccarthy :1971)))


(with-db facts
  (run* [q]
    (fresh [p y]
      (vital⁰ p :dead)
      (turing⁰ p y)
      (== q [p y]))))

(with-db facts
  (run* [p y]
    (vital⁰ p :dead)
    (turing⁰ p y)))

(run* [h t] (conso h t [:a :b :c]))


(defn inside⁰ [e l]
  (conde
    [(fresh [h t]
       (conso h t l)
       (== h e))]
    [(fresh [h t]
       (conso h t l)
       (inside⁰ e t))]))

(run* [q] (membero q [1 2 3]) (membero q [3 4 5]))
# => (3)

