(asdf:defsystem lifoo
  :description ""
  :author "Andreas <codr4life@gmail.com>"
  :license "MIT"
  :depends-on (:cl4l)
  :serial t
  :components ((:file "lifoo")
               (:file "lifoo-tests")))