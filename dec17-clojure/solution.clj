(ns solution
  (:gen-class))

(use '[clojure.string :only (join split-lines)])

(defn md5 [seed]
  (let [hash
         (doto (java.security.MessageDigest/getInstance "MD5")
               (.reset)
               (.update (.getBytes seed)))]
       (map (partial format "%02x") (.digest hash))))

(defn md5-prefix [seed] (join "" (take 2 (md5 seed))))

(defn can-move [c] (<= (int \b) (int c) (int \f)))

(defn moves [seed path] (map can-move (md5-prefix (str seed path))))

(moves "hijkl" "")


(can-move (.charAt "4" 0))


(defn -main [& args]
  (let [fname (if args (first args) "input.txt")
        inputs (clojure.string/split-lines (slurp fname))]
    (println (md5 "hijkl"))))
