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
    
    public partial class tblcart
    {
        public int Cartid { get; set; }
        public int GlassID { get; set; }
        public int Variationid { get; set; }
        public int Quantity { get; set; }
        public string LensType { get; set; }
        public string VisionType { get; set; }
        public string UVProtection { get; set; }
        public double TotalAmount { get; set; }
        public int Userid { get; set; }
        public string r_sph { get; set; }
        public string r_cyl { get; set; }
        public string r_axis { get; set; }
        public string r_add { get; set; }
        public string l_sph { get; set; }
        public string l_cyl { get; set; }
        public string l_axis { get; set; }
        public string l_add { get; set; }
        public Nullable<double> PD { get; set; }
        public string PDImage { get; set; }
        public string PrescriptionImage { get; set; }
        public string Title { get; set; }
        public string shape { get; set; }
        public string Colour { get; set; }
        public Nullable<double> Price { get; set; }
        public string ProductImagePath { get; set; }
        public string Size { get; set; }
        public string Productcategory { get; set; }
        public Nullable<double> TaxAmount { get; set; }
        public Nullable<double> Discount { get; set; }
        public Nullable<double> Shippingamount { get; set; }
        public Nullable<double> GranTotal { get; set; }
        public string Fname { get; set; }
        public string Lname { get; set; }
        public string prescription { get; set; }
        public Nullable<System.DateTime> prescriptionDate { get; set; }
        public Nullable<int> Extracharges { get; set; }
        public int CouponID { get; set; }
        public string CouponCode { get; set; }
        public Nullable<double> Discountamount { get; set; }
        public Nullable<double> Rightpd { get; set; }
        public string Segmentheight { get; set; }
        public Nullable<int> Dualpd { get; set; }
        public Nullable<int> Prescriptionid { get; set; }
    }
}
