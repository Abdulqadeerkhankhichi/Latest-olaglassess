using Olaglasses.Models;
using Olaglasses.UpsRate;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    public class upsapiController : Controller
    {

        // GET: upsapi
        public JsonResult Index(string City, string PostalCode, string StateProvinceCode, string CountryCode, string weight)
        {
            var model = new RatePackage();
            string code = "";
            string MonetaryValue = "";
            try
            {


                //Address Validation
                //var url = "https://wwwcie.ups.com/rest/AV";

                //var httpRequest = (HttpWebRequest)WebRequest.Create(url);
                //httpRequest.Method = "POST";

                //httpRequest.Accept = "application/json";
                //httpRequest.ContentType = "application/json";

                //var data = @"{""AccessLicenseNumber"": 8DB5613A3C7618D5,""UserId"": ""EyecarehawaiiECH"",""Password"": ""@Cornea123*()"",}";

                //using (var streamWriter = new StreamWriter(httpRequest.GetRequestStream()))
                //{
                //    streamWriter.Write(data);
                //}

                //var httpResponse = (HttpWebResponse)httpRequest.GetResponse();
                //using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                //{
                //    var result = streamReader.ReadToEnd();
                //}

                //Console.WriteLine(httpResponse.StatusCode);




                UPSSecurity upss = new UPSSecurity();


                UPSSecurityServiceAccessToken upssSvcAccessToken = new UPSSecurityServiceAccessToken();
                upssSvcAccessToken.AccessLicenseNumber = "8DB5613A3C7618D5";
                upss.ServiceAccessToken = upssSvcAccessToken;


                UPSSecurityUsernameToken upssUsrNameToken = new UPSSecurityUsernameToken();
                upssUsrNameToken.Username = "EyecarehawaiiECH";
                upssUsrNameToken.Password = "@Cornea123*()";
                upss.UsernameToken = upssUsrNameToken;

                RateRequest rateRequest = new RateRequest();

                RequestType request = new RequestType();
                String[] requestOption = { "Rate" };
                request.RequestOption = requestOption;
                rateRequest.Request = request;


                ShipmentType shipment = new ShipmentType();

                ShipperType shipper = new ShipperType();
                var shipperAddress = new AddressType();
                //shipperAddress.City = "Marietta";
                //shipperAddress.PostalCode = "30076";
                //shipperAddress.StateProvinceCode = "GA";
                //shipperAddress.CountryCode = "US";


                shipperAddress.City = "Marietta";
                shipperAddress.PostalCode = "30076";
                shipperAddress.StateProvinceCode = "GA";
                shipperAddress.CountryCode = "US";
                shipper.Address = shipperAddress;
                shipment.Shipper = shipper;

                ShipFromType shipFrom = new ShipFromType();
                var shipFromAddress = new ShipAddressType();
                shipFromAddress.City = "Marietta";
                shipFromAddress.PostalCode = "30076";
                shipFromAddress.StateProvinceCode = "GA";
                shipFromAddress.CountryCode = "US";
                shipFrom.Address = shipFromAddress;
                shipment.ShipFrom = shipFrom;


                ShipToType shipTo = new ShipToType();
                ShipToAddressType shipToAddress = new ShipToAddressType();
                shipToAddress.City = City;
                shipToAddress.PostalCode = PostalCode;
                shipToAddress.StateProvinceCode = StateProvinceCode;
                shipToAddress.CountryCode = CountryCode;


                //shipToAddress.City = "San Jose";
                //shipToAddress.PostalCode = "95113";
                //shipToAddress.StateProvinceCode = "CA";
                //shipToAddress.CountryCode = "US";
                shipTo.Address = shipToAddress;
                shipment.ShipTo = shipTo;


                CodeDescriptionType service = new CodeDescriptionType();
                service.Code = "03";
                shipment.Service = service;

                PackageType package = new PackageType();
                PackageWeightType packageWeight = new PackageWeightType();
                packageWeight.Weight = weight;
                //packageWeight.Weight = "1";
                CodeDescriptionType uom = new CodeDescriptionType();
                uom.Code = "LBS";
                uom.Description = "pounds";
                packageWeight.UnitOfMeasurement = uom;
                package.PackageWeight = packageWeight;
                CodeDescriptionType packType = new CodeDescriptionType();
                packType.Code = "02";
                package.PackagingType = packType;
                PackageType[] pkgArray = { package };


                shipment.Package = pkgArray;

                rateRequest.Shipment = shipment;
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls | System.Net.SecurityProtocolType.Tls11; //This line will ensure the latest security protocol for consuming the web service call.
                Console.WriteLine(rateRequest);
                var client = new RatePortTypeClient();


                RateResponse rateresponse = client.ProcessRate(upss, rateRequest);

                model = new RatePackage()
                {
                    Response = rateresponse
                };
                //Console.WriteLine("The transaction was a " + rateresponse.ResponseStatus.Description);
                //Console.WriteLine("Total Shipment Charges " + rateResponse.RatedShipment[0].TotalCharges.MonetaryValue + rateResponse.RatedShipment[0].TotalCharges.CurrencyCode);
                //Console.ReadKey();
                var Details = model.Response.RatedShipment;

                foreach (var item in Details)
                {
                    code = item.Service.Code;
                    MonetaryValue = item.TotalCharges.MonetaryValue;
                }


                return Json(new { servicecode = code, MonetaryValue = MonetaryValue, Exception = "1" });
                //return View(model);
            }
            catch (System.Web.Services.Protocols.SoapException ex)
            {
                Console.WriteLine("" + ex.Code);
                Console.WriteLine("---------Rate Web Service returns error----------------");
                Console.WriteLine("---------\"Hard\" is user error \"Transient\" is system error----------------");
                Console.WriteLine("SoapException Message= " + ex.Message);
                Console.WriteLine("");
                Console.WriteLine("SoapException Category:Code:Message= " + ex.Detail.LastChild.InnerText);
                Console.WriteLine("");
                Console.WriteLine("SoapException XML String for all= " + ex.Detail.LastChild.OuterXml);
                Console.WriteLine("");
                Console.WriteLine("SoapException StackTrace= " + ex.StackTrace);
                Console.WriteLine("-------------------------");
                Console.WriteLine("");
                ViewBag.Error = ex.Message + "SoapException Category:Code:Message= " + ex.Detail.LastChild.InnerText;
                return Json(new { servicecode = code, MonetaryValue = MonetaryValue, Exception = ex.Code });
            }
            catch (System.ServiceModel.CommunicationException ex)
            {
                Console.WriteLine("");
                Console.WriteLine("--------------------");
                Console.WriteLine("CommunicationException= " + ex.Message);
                Console.WriteLine("CommunicationException-StackTrace= " + ex.StackTrace);
                Console.WriteLine("-------------------------");
                Console.WriteLine("");
                ViewBag.Error = ex.Message + "CommunicationException-StackTrace= " + ex.StackTrace;
                return Json(new { servicecode = code, MonetaryValue = MonetaryValue, Exception = ViewBag.Error });

            }
            catch (Exception ex)
            {
                Console.WriteLine("");
                Console.WriteLine("-------------------------");
                Console.WriteLine(" Generaal Exception= " + ex.Message);
                Console.WriteLine(" Generaal Exception-StackTrace= " + ex.StackTrace);
                Console.WriteLine("-------------------------");

                ViewBag.Error = ex.Message + " Generaal Exception-StackTrace= " + ex.StackTrace;
                return Json(new { servicecode = code, MonetaryValue = MonetaryValue, Exception = ViewBag.Error });
            }
            finally
            {
                //Console.ReadKey();
            }

            return Json(new { servicecode = code, MonetaryValue = MonetaryValue, Exception = "1" }); ;

        }
    }
}