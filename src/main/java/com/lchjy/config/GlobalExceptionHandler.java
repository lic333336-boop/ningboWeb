package com.lchjy.config;

import com.lchjy.utils.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.resource.NoResourceFoundException; //

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(Exception.class)
    public Result systemError(Exception e) {
        // === 新增：针对 favicon.ico 缺失的特殊处理 ===
        // 判断是否为静态资源未找到异常 (Spring Boot 3.2+ / Spring Framework 6.1+)
        if (e instanceof NoResourceFoundException) {
            NoResourceFoundException ne = (NoResourceFoundException) e;
            // 检查缺失的资源是否为 favicon.ico
            if ("favicon.ico".equals(ne.getResourcePath())) {
                // 仅打印警告日志，不打印堆栈信息，避免刷屏
                log.warn("检测到 favicon.ico 请求缺失，已忽略堆栈信息打印。");
                return Result.error("Favicon not found");
            }
        }

        // === 原有逻辑：其他异常打印完整堆栈 ===
        e.printStackTrace();
        log.error("系统运行异常: ", e);
        return Result.error("系统运行异常，请查看控制台日志");
    }
}