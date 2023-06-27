package com.notice.scheduler;

import com.notice.register.mapper.RegisterMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@Slf4j
@EnableScheduling
public class ScheduleTest {

//    @Scheduled(fixedRate = 3000)
//    public void scheduleTestMethod(){
//        log.debug("5초에 한번씩 실행한다");
//    }


}
