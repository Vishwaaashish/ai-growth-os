import uuid
from starlette.middleware.base import BaseHTTPMiddleware
from app.core.logger import logger


class TraceMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        trace_id = str(uuid.uuid4())

        request.state.trace_id = trace_id

        response = await call_next(request)

        logger.info(
            "request_completed",
            extra={"trace_id": trace_id}
        )

        response.headers["X-Trace-ID"] = trace_id
        return response
