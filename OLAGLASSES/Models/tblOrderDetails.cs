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
    
    public partial class tblOrderDetails
    {
        public int OrderDetailID { get; set; }
        public Nullable<int> OrderID { get; set; }
        public Nullable<int> ProductID { get; set; }
        public string Productname { get; set; }
        public string ProductPrice { get; set; }
        public Nullable<System.DateTime> OrderDate { get; set; }
        public string Vision { get; set; }
        public string LensType { get; set; }
        public string UV_Protection { get; set; }
        public string Total { get; set; }
        public Nullable<int> ProductVariation { get; set; }
        public Nullable<int> quantity { get; set; }
        public Nullable<double> TaxAmount { get; set; }
        public Nullable<double> Discount { get; set; }
        public string FrameColor { get; set; }
        public string ProductImage { get; set; }
        public Nullable<double> ShippingAmount { get; set; }
        public Nullable<double> Subtotal { get; set; }
    }
}