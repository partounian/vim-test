source spec/support/helpers.vim

describe "ParaTest"

  before
    cd spec/fixtures/phpunit
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view NormalTest.php
    TestFile

    Expect g:test#last_command == 'paratest --colors NormalTest.php'
  end

  it "runs nearest tests"
    view +1 NormalTest.php
    TestNearest

    Expect g:test#last_command == "paratest --colors NormalTest.php"

    view +9 NormalTest.php
    TestNearest

    Expect g:test#last_command == "paratest --colors --filter '::testShouldAddTwoNumbers' NormalTest.php"

    view +14 NormalTest.php
    TestNearest

    Expect g:test#last_command == "paratest --colors --filter '::testShouldSubtractTwoNumbers' NormalTest.php"

    view +30 NormalTest.php
    TestNearest

    Expect g:test#last_command == "paratest --colors --filter '::testShouldAddToExpectedValue' NormalTest.php"
  end

  it  "runs nearest test marked with @test annotation"
    view +40 NormalTest.php
    TestNearest

    Expect g:test#last_command == "paratest --colors --filter '::aTestMarkedWithTestAnnotation' NormalTest.php"

    view +50 NormalTest.php
    TestNearest

    Expect g:test#last_command == "paratest --colors --filter '::aTestMarkedWithTestAnnotationAndCrazyDocblock' NormalTest.php"
  end

  it  "runs nearest test containing an anonymous class"
    view +61 NormalTest.php
    TestNearest

    Expect g:test#last_command == "paratest --colors --filter '::testWithAnAnonymousClass' NormalTest.php"

    view +76 NormalTest.php
    TestNearest

    Expect g:test#last_command == "paratest --colors --filter '::aTestMakedWithTestAnnotationAndWithAnAnonymousClass' NormalTest.php"
  end

  " Fix for: https://github.com/janko/vim-test/issues/361
  it "runs nearest test with a one line @test annotation"
    view +83 NormalTest.php
    TestNearest

    Expect g:test#last_command == "paratest --colors --filter '::aTestMarkedWithTestAnnotationOnOneLine' NormalTest.php"
  end

  it "runs test suites"
    view NormalTest.php
    TestSuite

    Expect g:test#last_command == 'paratest --colors'
  end

  it "doesn't recognize files that don't end with 'Test'"
    view normal.php
    TestFile

    Expect exists('g:test#last_command') == 0
  end

end