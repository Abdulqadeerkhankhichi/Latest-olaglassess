//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Olaglasses.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblSetting
    {
        public int ID { get; set; }
        public string clientId { get; set; }
        public string clientSecret { get; set; }
        public string AccountType { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string SMTP { get; set; }
        public string Port { get; set; }
        public bool IsActive { get; set; }
        public string StripeID { get; set; }
        public string ReceipentEmail { get; set; }
    }
}
