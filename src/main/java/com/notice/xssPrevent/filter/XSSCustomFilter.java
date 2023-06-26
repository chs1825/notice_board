package com.notice.xssPrevent.filter;

import com.notice.xssPrevent.wrappers.XSSRequestWrapper;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public class XSSCustomFilter implements Filter {
//    private FilterConfig filterConfig;
    private boolean isXssEscapeServletFilterActive;


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
//        this.filterConfig = filterConfig;
//        isXssEscapeServletFilterActive = isXssEscapeServletFilterActive(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        XSSRequestWrapper wrappedRequest = new XSSRequestWrapper(httpRequest);
        chain.doFilter(wrappedRequest, response);


        //루시가 작동안하면 커스텀 래퍼 적용
//        if (!isXssEscapeServletFilterActive) {
//            XSSRequestWrapper wrappedRequest = new XSSRequestWrapper(httpRequest);
//            chain.doFilter(wrappedRequest, response);
//            // XSSCustomFilter 작동하는 로직을 여기에 작성합니다.
//        }else { //루시 작동하면 미적용
//            chain.doFilter(request, response);
//        }


    }

    @Override
    public void destroy() {

    }

    //루시 작동여부 체크 메소드
    private boolean isXssEscapeServletFilterActive(FilterConfig filterConfig) {
        FilterRegistration xssEscapeFilterRegistration = filterConfig.getServletContext()
                .getFilterRegistration("xssEscapeServletFilter");
        if (xssEscapeFilterRegistration != null) {
            String policyFile = xssEscapeFilterRegistration.getInitParameter("policyFile");
            return policyFile != null;
        }
        return false;
    }
}
