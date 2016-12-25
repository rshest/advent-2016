(ns solution)

(use '[clojure.string :only (join split-lines)])

(def width 4)
(def height 4)
(def captions ["U" "D", "L", "R"])
(def offsets [[0 -1] [0 1] [-1 0] [1 0]])


(defn md5 [str]
    (->> (doto (java.security.MessageDigest/getInstance "MD5")
               (.reset)
               (.update (.getBytes str)))
         (.digest)
         (map (partial format "%02x"))))


(defn can-move [c]
  (<= (int \b) (int c) (int \f)))

(defn opened-doors [seed path]
    (->> (str seed path)
         (md5) (take 2) (join "") (map can-move)))

(defn in-bounds [[x y]]
  (and (< -1 x width) (< -1 y height)))

(defn at-target [[x y]]
  (and (= width  (inc x)) (= height (inc y))))

(defn find-paths [seed start-pos]
  (loop [queue [[start-pos ""]]
         paths []]
    (if (empty? queue) paths ; finished traversing
     (let [[pos path] (first queue)
           steps      (map #(map + pos %) offsets)
           opened     (map #(and (in-bounds %1) %2)
                           steps (opened-doors seed path))]
      (if (at-target pos)
        (recur (rest queue) (conj paths path)) ; reached destination, add path
        (recur (remove nil? (concat (rest queue)
                                    (map #(if %1 [%2 (str path %3)])
                                         opened steps captions)))
               paths))))))

(defn solve [seed]
  (let [paths (sort-by count (find-paths seed [0 0]))]
    (print "Seed: " seed "\n Shortests path: " (first paths)
           "\n Longest path size: " (->> paths last count) "\n")))


(defn -main [& args]
  (let [fname (if args (first args) "input.txt")
        inputs (clojure.string/split-lines (slurp fname))]
    (doall (map solve inputs))))
