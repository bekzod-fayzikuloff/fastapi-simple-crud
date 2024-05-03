import uvicorn
from fastapi import FastAPI

from app.config.settings import load_application_config
from app.config.events import on_startup, on_shutdown


def setup_app():
    application = FastAPI(**load_application_config())

    application.add_event_handler("startup", on_startup)
    application.add_event_handler("shutdown", on_shutdown)
    return application


if __name__ == "__main__":
    uvicorn.run(setup_app())
