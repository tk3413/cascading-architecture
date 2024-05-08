"""
step implementation for happy paths in code

author: taimore khan
"""

from behave import given, then, when  # pylint: disable=no-name-in-module

from src.hello import hello  # pylint: disable=import-error


@given("we have some code")
def given_hello(context) -> None:
    """
    doesn't do much because this code doesn't need setup
    """
    context.setup = None


@when("it is called")
def when_function_is_called(context) -> None:
    """
    applies the code under test
    """
    context.result = hello(name="taimore")
    print(f"result is: {context.result}")


@then("we are able to validate the result")
def then_assert(context):
    """
    applies assertion to verify code behaves as expected
    """
    assert context.result == "hello taimore"
