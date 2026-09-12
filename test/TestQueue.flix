mod TestQueue {

    use Assert.{assertEq, assertNeq, assertTrue, assertFalse, assertNone, fail};
    use Extras.Queue

    /////////////////////////////////////////////////////////////////////////////
    // empty                                                                   //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def empty01(): Unit \ Assert =
        let q: Queue[Int32] = Queue.empty();
        assertEq(expected = Nil, Queue.toList(q))

    @Test
    def empty02(): Unit \ Assert =
        let q: Queue[String] = Queue.empty();
        assertTrue(Queue.isEmpty(q))

    @Test
    def empty03(): Unit \ Assert =
        let q: Queue[Int32] = Queue.empty();
        assertEq(expected = 0, Queue.size(q))

    /////////////////////////////////////////////////////////////////////////////
    // isEmpty                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def isEmpty01(): Unit \ Assert =
        let q: Queue[Int32] = Queue.empty();
        assertTrue(Queue.isEmpty(q))

    @Test
    def isEmpty02(): Unit \ Assert =
        assertFalse(Queue.isEmpty(Queue.enqueue(1, Queue.empty())))

    @Test
    def isEmpty03(): Unit \ Assert =
        // A queue emptied by dequeue is empty again.
        match Queue.dequeue(Queue.enqueue(1, Queue.empty())) {
            case Some((_, rest)) => assertTrue(Queue.isEmpty(rest))
            case None            => fail("expected a non-empty queue")
        }

    /////////////////////////////////////////////////////////////////////////////
    // size                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def size01(): Unit \ Assert =
        let q: Queue[Int32] = Queue.empty();
        assertEq(expected = 0, Queue.size(q))

    @Test
    def size02(): Unit \ Assert =
        assertEq(expected = 1, Queue.size(Queue.enqueue(1, Queue.empty())))

    @Test
    def size03(): Unit \ Assert =
        // Counts elements in both the front and the back list.
        let q = Queue.enqueue(3, Queue.enqueue(2, Queue.fromList(1 :: Nil)));
        assertEq(expected = 3, Queue.size(q))

    /////////////////////////////////////////////////////////////////////////////
    // enqueue                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def enqueue01(): Unit \ Assert =
        assertEq(expected = 1 :: Nil, Queue.toList(Queue.enqueue(1, Queue.empty())))

    @Test
    def enqueue02(): Unit \ Assert =
        let q = Queue.enqueue(2, Queue.enqueue(1, Queue.empty()));
        assertEq(expected = 1 :: 2 :: Nil, Queue.toList(q))

    @Test
    def enqueue03(): Unit \ Assert =
        // Enqueueing leaves the original queue unchanged.
        let q1 = Queue.fromList(1 :: Nil);
        let q2 = Queue.enqueue(2, q1);
        assertEq(expected = 1 :: Nil, Queue.toList(q1));
        assertEq(expected = 1 :: 2 :: Nil, Queue.toList(q2))

    /////////////////////////////////////////////////////////////////////////////
    // dequeue                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def dequeue01(): Unit \ Assert =
        let q: Queue[Int32] = Queue.empty();
        assertNone(Queue.dequeue(q))

    @Test
    def dequeue02(): Unit \ Assert =
        match Queue.dequeue(Queue.fromList(1 :: 2 :: 3 :: Nil)) {
            case Some((x, rest)) =>
                assertEq(expected = 1, x);
                assertEq(expected = 2 :: 3 :: Nil, Queue.toList(rest))
            case None            => fail("expected a non-empty queue")
        }

    @Test
    def dequeue03(): Unit \ Assert =
        // Elements leave in the order they were enqueued, even when the front
        // list must be refilled from the back list.
        let q = Queue.enqueue(3, Queue.enqueue(2, Queue.enqueue(1, Queue.empty())));
        match Queue.dequeue(q) {
            case Some((x, rest)) =>
                assertEq(expected = 1, x);
                assertEq(expected = 2 :: 3 :: Nil, Queue.toList(rest))
            case None            => fail("expected a non-empty queue")
        }

    /////////////////////////////////////////////////////////////////////////////
    // peek                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def peek01(): Unit \ Assert =
        let q: Queue[Int32] = Queue.empty();
        assertNone(Queue.peek(q))

    @Test
    def peek02(): Unit \ Assert =
        assertEq(expected = Some(1), Queue.peek(Queue.fromList(1 :: 2 :: Nil)))

    @Test
    def peek03(): Unit \ Assert =
        // Peeking finds the new front element after the back list has been
        // reversed into the front.
        let q = Queue.enqueue(3, Queue.enqueue(2, Queue.enqueue(1, Queue.empty())));
        match Queue.dequeue(q) {
            case Some((_, rest)) => assertEq(expected = Some(2), Queue.peek(rest))
            case None            => fail("expected a non-empty queue")
        }

    /////////////////////////////////////////////////////////////////////////////
    // toList                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def toList01(): Unit \ Assert =
        let q: Queue[Int32] = Queue.empty();
        assertEq(expected = Nil, Queue.toList(q))

    @Test
    def toList02(): Unit \ Assert =
        // Returns queue order across both the front and the back list.
        let q = Queue.enqueue(3, Queue.enqueue(2, Queue.fromList(1 :: Nil)));
        assertEq(expected = 1 :: 2 :: 3 :: Nil, Queue.toList(q))

    @Test
    def toList03(): Unit \ Assert =
        // Returns queue order after the back list has been reversed into the front.
        let q = Queue.enqueue(3, Queue.enqueue(2, Queue.enqueue(1, Queue.empty())));
        match Queue.dequeue(q) {
            case Some((_, rest)) => assertEq(expected = 2 :: 3 :: Nil, Queue.toList(rest))
            case None            => fail("expected a non-empty queue")
        }

    /////////////////////////////////////////////////////////////////////////////
    // fromList                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def fromList01(): Unit \ Assert =
        let q: Queue[Int32] = Queue.fromList(Nil);
        assertTrue(Queue.isEmpty(q))

    @Test
    def fromList02(): Unit \ Assert =
        assertEq(expected = 1 :: 2 :: 3 :: Nil, Queue.toList(Queue.fromList(1 :: 2 :: 3 :: Nil)))

    @Test
    def fromList03(): Unit \ Assert =
        // The head of the list is at the front of the queue.
        assertEq(expected = Some("a"), Queue.peek(Queue.fromList("a" :: "b" :: Nil)))

    /////////////////////////////////////////////////////////////////////////////
    // Eq.eq                                                                   //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def eq01(): Unit \ Assert =
        let q1: Queue[Int32] = Queue.empty();
        let q2: Queue[Int32] = Queue.fromList(Nil);
        assertEq(expected = q1, q2)

    @Test
    def eq02(): Unit \ Assert =
        // Equality is by queue order, not by representation: these two queues hold
        // the same elements but split them differently across front and back.
        let q1 = Queue.fromList(1 :: 2 :: Nil);
        let q2 = Queue.enqueue(2, Queue.enqueue(1, Queue.empty()));
        assertEq(expected = q1, q2)

    @Test
    def eq03(): Unit \ Assert =
        assertNeq(unexpected = Queue.fromList(1 :: 2 :: Nil), Queue.fromList(2 :: 1 :: Nil))

    /////////////////////////////////////////////////////////////////////////////
    // ToString.toString                                                       //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def toString01(): Unit \ Assert =
        let q: Queue[Int32] = Queue.empty();
        assertEq(expected = "Queue#{}", ToString.toString(q))

    @Test
    def toString02(): Unit \ Assert =
        assertEq(expected = "Queue#{1}", ToString.toString(Queue.fromList(1 :: Nil)))

    @Test
    def toString03(): Unit \ Assert =
        // Prints in queue order across both the front and the back list.
        let q = Queue.enqueue(3, Queue.enqueue(2, Queue.fromList(1 :: Nil)));
        assertEq(expected = "Queue#{1, 2, 3}", ToString.toString(q))

}
