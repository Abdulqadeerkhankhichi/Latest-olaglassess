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
    
    public partial class tblFavourite
    {
        public int FavouriteID { get; set; }
        public Nullable<int> ProductID { get; set; }
        public Nullable<int> UserID { get; set; }
        public Nullable<System.DateTime> CreateDate { get; set; }
    }
}
