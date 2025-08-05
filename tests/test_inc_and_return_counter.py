import pytest

from src import inc_and_return_counter

def test_increment_views_exists():
    assert hasattr(inc_and_return_counter, 'increment_counter'), "No such function 'increment_counter'"

def test_increment_views_is_callable():
    assert callable(inc_and_return_counter.increment_counter), "'increment_counter' is not callable"

