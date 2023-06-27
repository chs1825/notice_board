package com.notice.aopTest;

import com.notice.aopTest.loggerUtil.LoggerUtils;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

@Aspect
//@Component >> ApplicationConfig 에서 @bean 선언해주었기 때문에 선언해주지 않아도 되는 어노테이션
@Slf4j
public class LoggingAspect {

    @Before("execution(* com.notice.*.controller..*.*(..))")
    public void logBefore(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getSimpleName();

        log.info("Accessing method " + methodName + " in class " + className);

        // 접속 로그 기록
        LoggerUtils.recordAccess(methodName);
    }


}
