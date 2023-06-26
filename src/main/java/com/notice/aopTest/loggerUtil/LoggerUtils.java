package com.notice.aopTest.loggerUtil;


import lombok.extern.slf4j.Slf4j;

@Slf4j
public class LoggerUtils {

    public static void recordAccess(String methodName){

        log.info("요것은 AOP에 의한 로깅이라네~");
        log.info("작동 method : {}", methodName);
    }

}
