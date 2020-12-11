class Main {
  Void main() {
    LL input;
    Helper h;
    h = new Helper();
    input = h.readInput();
    h.part1(input);
    h.part2(input);
  }
}

class Helper {
  LL readInput() {
    LL res;
    Int i;
    Int input;
    Int n;
    n = 200;
    i = 0;
    res = new LL();
    res.init();
    while (i < 200) {
      readln(input);
      res.append(input);
      i = i + 1;
    }
    return res;
  }

  Void part1(LL input) {
    LLNode i;
    Bool result;
    i = input.head;
    while (true) {
      if (part1(i, input)) {
        return;
      } else {
        if (i.hasTail) {
          i = i.tail;
        } else {
          return;
        }
      }
    }
  }

  Bool part1(LLNode i, LL input) {
    LLNode j;
    Bool dummy; // just to pass typechecking
    j = input.head;
    while (true) {
      if (i.value + j.value == 2020 && i.value != j.value) {
        println(i.value * j.value);
        return true;
        dummy = false;
      } else {
        if (j.hasTail) {
          j = j.tail;
        } else {
          return false;
          dummy = false;
        }
      }
    }
    return false;
  }

  Void part2(LL input) {
    LLNode i;
    Bool result;
    i = input.head;
    while (true) {
      if (part2(i, input)) {
        return;
      } else {
        if (i.hasTail) {
          i = i.tail;
        } else {
          return;
        }
      }
    }
  }

  Bool part2(LLNode i, LL input) {
    LLNode j;
    Bool dummy; // just to pass typechecking
    j = input.head;
    while (true) {
      if (i.value != j.value && part2(i, j, input)) {
        return true;
        dummy = false;
      } else {
        if (j.hasTail) {
          j = j.tail;
        } else {
          return false;
          dummy = false;
        }
      }
    }
    return false;
  }

  Bool part2(LLNode i, LLNode j, LL input) {
    Int iVal;
    Int jVal;
    Int kVal;
    LLNode k;
    Bool dummy; // just to pass typechecking
    k = input.head;
    while (true) {
      iVal = i.value;
      jVal = j.value;
      kVal = k.value;
      if (iVal != kVal && jVal != kVal && iVal + jVal + kVal == 2020) {
        println(iVal * jVal * kVal);
        return true;
        dummy = false;
      } else {
        if (k.hasTail) {
          k = k.tail;
        } else {
          return false;
          dummy = false;
        }
      }
    }
    return false;
  }
}

class LL {
  Bool isEmpty;
  LLNode head;
  LLNode tail;

  Void init() {
    this.isEmpty = true;
    this.head = null;
    this.tail = null;
  }

  Void append(Int value) {
    LLNode cur;
    cur = new LLNode();
    cur.value = value;
    cur.tail = null;
    cur.hasTail = false;
    if (this.isEmpty) {
      this.head = cur;
      this.tail = cur;
      this.isEmpty = false;
    } else {
      this.tail.hasTail = true;
      this.tail.tail = cur;
      this.tail = cur;
    }
  }
}

class LLNode {
  Int value;
  LLNode tail;
  Bool hasTail;
}
