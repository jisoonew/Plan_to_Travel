package com.ptt.controller;

import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ptt.model.UserVO;
import com.ptt.service.UserService;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class ServeController {
	private static final Logger log = LoggerFactory.getLogger(ServeController.class);
	
	@Autowired
	private UserService userservice;
	
	@Autowired
    private JavaMailSender mailSender;
	
	//로그인 페이지로 이동
	@RequestMapping(value = "/Login", method = RequestMethod.GET)
	public void loginPageGET() {
			
		log.info("Login 페이지 진입");
		//return "Login";
	}
	
    //로그인 기능
    @RequestMapping(value="/login", method=RequestMethod.POST)
    public String loginPOST(HttpServletRequest request, UserVO user, RedirectAttributes rttr) throws Exception{
        
    	HttpSession session = request.getSession();
    	UserVO lvo = userservice.userLogin(user);
        
        if(lvo == null) {                                // 일치하지 않는 아이디, 비밀번호 입력 경우
            
            int result = 0;
            rttr.addFlashAttribute("result", result);
            System.out.println(result);
            return "redirect:/Login";
            
        }
        
        session.setAttribute("user", lvo);             // 일치하는 아이디, 비밀번호 경우 (로그인 성공)
        
        // 아이디 값 -> 세션 저장
        String uID_session = request.getParameter("u_id");
        session.setAttribute("uID_session", uID_session);
        
        return "redirect:/Plan_to_travel";
    }
    
	
	//회원가입 페이지 이동
	@RequestMapping(value = "/Join", method = RequestMethod.GET)
	public void joinGET() {
			
		log.info("회원가입 페이지 진입");
		
	}
	
	//아이디 중복 검사
	@RequestMapping(value = "/userIdChk", method = RequestMethod.POST)
	@ResponseBody
	public String userIdChkPOST(String u_id) throws Exception{
		
		log.info("userIdChk() 진입");
		
		int result = userservice.idCheck(u_id);
		
		System.out.println("결과값  = " + result);
		
		if(result != 0) {
			
			//result = 0이 아니면 , fail, 중복 아이디 존재
			return "fail";	// 중복 아이디가 존재
			
		} else {
			
			//result = 0이면 , success, 아이디 사용 가능
			return "success";	// 중복 아이디 x
			
		}	
		
	} // memberIdChkPOST() 종료
	
	 
    // 이메일 인증 
    @RequestMapping(value="/emailCheck", method=RequestMethod.GET)
    @ResponseBody
    public String mailCheckGET(String email) throws Exception{
        
        /* 뷰(View)로부터 넘어온 데이터 확인 */
        log.info("이메일 데이터 전송 확인");
        log.info("인증 이메일 : " + email);
        
        /* 인증번호(난수) 생성 */
        Random random = new Random();
        int checkNum = random.nextInt(888888) + 111111;
        log.info("인증번호 " + checkNum);
        
        /* 이메일 보내기 */
        String setFrom = "jieun6980445@naver.com";
        String toMail = email;
        String title = "회원가입 인증 이메일 입니다.";
        String content = 
                "홈페이지를 방문해주셔서 감사합니다." +
                "<br><br>" + 
                "인증 번호는 " + checkNum + "입니다." + 
                "<br>" + 
                "해당 인증번호를 인증번호 확인란에 기입하여 주세요.";
       
       try {
            
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
            helper.setFrom(setFrom);
            helper.setTo(toMail);
            helper.setSubject(title);
            helper.setText(content,true);
            mailSender.send(message);
            
             
        }catch(Exception e) {
            e.printStackTrace();
        }
        
        String num = Integer.toString(checkNum); 
        
        return num;
        
    }
	
	//회원가입
	@RequestMapping(value="/Join", method=RequestMethod.POST)
	public String joinPOST(UserVO user) throws Exception{
		
		log.info("join 진입");
		
		// 회원가입 서비스 실행
		userservice.userJoin(user);

		
		log.info("join Service 성공");
	
		return "Login";
		
	}
	
	//아이디 찾기 페이지 이동
	@RequestMapping(value = "/findID", method = RequestMethod.GET)
	public void fidGET() {
			
		log.info("아이디 찾기 페이지 진입");
			
	}
	
	//비밀번호 찾기 페이지 이동
	@RequestMapping(value = "/findPW", method = RequestMethod.GET)
	public void fpwGET() {
		
		log.info("비밀번호 찾기 페이지 진입");
			
	}
	

}