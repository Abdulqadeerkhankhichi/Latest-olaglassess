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
    
    public partial class tblReviewLike
    {
        public int ReviewLikeID { get; set; }
        public Nullable<int> ReviewID { get; set; }
        public Nullable<int> UserID { get; set; }
        public Nullable<int> Productid { get; set; }
    }
}
