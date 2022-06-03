using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Models
{
    public class Customexception : FilterAttribute, IExceptionFilter
    {
        
        private OlaGlassesEntities dbEntities = new OlaGlassesEntities();
        public void OnException(ExceptionContext filterContext)
        {




            //Send error to email
            //DataTable dt = new DataTable();
            //string EmailQuery = "select * from tblSettings";
            //dt = ut.GetDatatable(EmailQuery);

            var email = dbEntities.tblSettings.FirstOrDefault();
            var controllerName = filterContext.RouteData.Values["controller"];
            var actionName = filterContext.RouteData.Values["action"];
            //using (MailMessage mm = new MailMessage(email.Email.ToString(), "hasanbilal369@gmail.com"))
            //{

            //    mm.Subject = "Exception occur";
            //    string body = "Hello Admin Olaglasses";
            //    body += "<br /><br />Date :" + DateTime.Now;
            //    body += "<br /><br />Controller Name:" + controllerName;
            //    body += "<br /><br />Action Name:" + actionName;
            //    body += "<br /><br />Exception:" + filterContext.Exception.Message;
            //    mm.Body = body;
            //    mm.IsBodyHtml = true;
            //    SmtpClient smtp = new SmtpClient();
            //    smtp.Host = email.SMTP.ToString();
            //    smtp.EnableSsl = Convert.ToBoolean(email.IsActive);
            //    NetworkCredential NetworkCred = new NetworkCredential(email.Email, email.Password);
            //    smtp.UseDefaultCredentials = true;
            //    smtp.Credentials = NetworkCred;
            //    smtp.Port = Convert.ToInt32(email.Port);
            //    smtp.Send(mm);
            //}

            //save error to textfile
            string temp = AppDomain.CurrentDomain.BaseDirectory;
            string sPath = Path.Combine(temp, "Error_Log.txt");
            string errordetail = "";

            errordetail = "----------------------------------------------------------------------------------------------";
            errordetail += "\r\n" + "Date: " + DateTime.Now.ToString();
            errordetail += "\r\n" + "Controller Name: " + controllerName;
            errordetail += "\r\n" + "Action Name: " + actionName;
            errordetail += "\r\n" + "Exception: " + filterContext.Exception.Message;
            var st = new System.Diagnostics.StackTrace(filterContext.Exception, true);
            var frame = st.GetFrame(st.FrameCount - 1);
            var linenumber = frame.GetFileLineNumber(); // returns only 0 its wrong error line num is 72
            errordetail += "\r\n" + filterContext.Exception.StackTrace.ToString();
           bool fileExist = File.Exists(sPath);
            if (fileExist)
            {

                File.AppendAllText(sPath, "\r\n" + errordetail);
                //Console.WriteLine("File exists.");
            }
            else
            {
                using (File.Create(sPath)) ;
                //Console.WriteLine("File does not exist.");
            }


            //throw new NotImplementedException();
            filterContext.Result = new ViewResult()
            {
                //ViewName = "error"
                ViewName = "error"
            };
            filterContext.ExceptionHandled = true;

        }
    }
}