#!/bin/sh
exec scala "$0" "$@"
!#

object Ans extends App {
  val in = Iterator.continually(io.StdIn.readLine()).takeWhile(_!=null).map(_.toInt).toSet
  println(in.subsets(2).find(_.sum==2020).get.product)
  println(in.subsets(3).find(_.sum==2020).get.product)
}
