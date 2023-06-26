package com.notice.xssPrevent.wrappers;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringEscapeUtils;
import org.owasp.encoder.Encode;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

@Slf4j
public class XSSRequestWrapper extends HttpServletRequestWrapper {
    /**
     * Constructs a request object wrapping the given request.
     *
     * @param request
     * @throws IllegalArgumentException if the request is null
     */
    public XSSRequestWrapper(HttpServletRequest request) {
        super(request);
    }


    @Override
    public String getParameter(String name) {

        String value = super.getParameter(name);
        return santize(value);
    }

    @Override
    public String[] getParameterValues(String name) {
        String[] values = super.getParameterValues(name);
        if(values == null){
            return null;
        }
        int count = values.length;
        String[] sanitizesValues = new String[count];
        for (int i =0; i < count; i++){
            sanitizesValues[i] = santize(values[i]);
        }
        return sanitizesValues;
    }

    private String santize(String value) {

        if(value != null){
            /*// HTML 이스케이프
            value = StringEscapeUtils.escapeHtml4(value);
            // JavaScript 이스케이프
            value = StringEscapeUtils.escapeEcmaScript(value);
            // 필요에 따라 추가적인 필터링 로직을 적용할 수 있습니다.

            value = value.replaceAll("<", "&lt;"); // < 기호를 HTML 엔티티 &lt;로 대체
            value = value.replaceAll(">", "&gt;"); // > 기호를 HTML 엔티티 &gt;로 대체*/


            // HTML 이스케이프
            log.debug("필터작동!!!!! : 변환전 value!!!!!!!");
            log.debug("value : {}" , value);
            value = Encode.forHtml(value);
            // JavaScript 이스케이프
//            value = Encode.forJavaScript(value);
            // 필요에 따라 추가적인 필터링 로직을 적용할 수 있습니다.
            log.debug("필터작동!!!!! : 변환된 value!!!!!!!");
            log.debug("value : {}" , value);
        }
        return value;
    }
}
