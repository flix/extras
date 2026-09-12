/*
 * Copyright 2026 Flix Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pub mod Extras.Queue {

    ///
    /// The Queue type.
    ///
    /// An immutable first-in, first-out (FIFO) queue.
    ///
    /// A queue is represented as a pair of lists: a front list, in queue order,
    /// and a back list, in reverse queue order. Elements are dequeued from the
    /// front and enqueued onto the back. When the front is exhausted the back is
    /// reversed to become the new front, which gives `enqueue`, `dequeue`, and
    /// `peek` amortized constant time.
    ///
    /// The representation maintains the invariant that the front list is empty
    /// only if the queue itself is empty.
    ///
    /// Note - the constructor `Queue` should not be used directly.
    ///
    pub enum Queue[a] {
        case Queue(List[a], List[a])
    }

    instance Eq[Queue[a]] with Eq[a] {
        pub def eq(q1: Queue[a], q2: Queue[a]): Bool = Queue.toList(q1) == Queue.toList(q2)
    }

    instance ToString[Queue[a]] with ToString[a] {
        pub def toString(q: Queue[a]): String = "Queue#{" + List.join(", ", Queue.toList(q)) + "}"
    }

    ///
    /// Returns the empty queue.
    ///
    pub def empty(): Queue[a] = Queue.Queue(Nil, Nil)

    ///
    /// Returns `true` if and only if the queue `q` is empty.
    ///
    pub def isEmpty(q: Queue[a]): Bool = match q {
        case Queue.Queue(front, _) => List.isEmpty(front)
    }

    ///
    /// Returns the number of elements in the queue `q`.
    ///
    pub def size(q: Queue[a]): Int32 = match q {
        case Queue.Queue(front, back) => List.length(front) + List.length(back)
    }

    ///
    /// Returns the queue `q` with the element `x` added to its back.
    ///
    pub def enqueue(x: a, q: Queue[a]): Queue[a] = match q {
        case Queue.Queue(front, back) => unit(front, x :: back)
    }

    ///
    /// Returns `Some((x, rest))` where `x` is the element at the front of the
    /// queue `q` and `rest` is `q` without `x`.
    ///
    /// Returns `None` if the queue `q` is empty.
    ///
    pub def dequeue(q: Queue[a]): Option[(a, Queue[a])] = match q {
        case Queue.Queue(Nil, _)            => None
        case Queue.Queue(x :: front, back)  => Some((x, unit(front, back)))
    }

    ///
    /// Returns `Some(x)` where `x` is the element at the front of the queue `q`.
    ///
    /// Returns `None` if the queue `q` is empty.
    ///
    pub def peek(q: Queue[a]): Option[a] = match q {
        case Queue.Queue(front, _) => List.head(front)
    }

    ///
    /// Returns the elements of the queue `q` as a list, in queue order.
    ///
    pub def toList(q: Queue[a]): List[a] = match q {
        case Queue.Queue(front, back) => List.append(front, List.reverse(back))
    }

    ///
    /// Returns a queue holding the elements of the list `l`, where the head of
    /// `l` is at the front of the queue.
    ///
    pub def fromList(l: List[a]): Queue[a] = Queue.Queue(l, Nil)

    ///
    /// Returns a queue holding the elements of `front` followed by the reverse of
    /// `back`, restoring the invariant that the front is empty only if the queue
    /// is empty.
    ///
    def unit(front: List[a], back: List[a]): Queue[a] = match front {
        case Nil => Queue.Queue(List.reverse(back), Nil)
        case _   => Queue.Queue(front, back)
    }

}
