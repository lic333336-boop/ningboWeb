package com.lchjy.config;

import com.lchjy.utils.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(Exception.class)
    public Result systemError(Exception e) {
        //TODO
        // === 修改点：一定要打印堆栈信息，否则看不到具体错在哪 ===
        e.printStackTrace();
        log.error("系统运行异常: ", e);
        return Result.error("系统运行异常，请查看控制台日志");
    }
}