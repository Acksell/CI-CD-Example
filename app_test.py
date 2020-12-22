import pytest
from app import app as flask_app


@pytest.fixture
def app():
    yield flask_app


def test_hello_world(app):
    with app.test_client() as client:
        res = client.get('/hello')
        assert res.status_code == 200
        assert res.get_data(as_text=True) == "Hello, Watchtower!"
