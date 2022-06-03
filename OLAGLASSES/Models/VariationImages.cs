using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Olaglasses.Models
{
    public class VariationImages
    {
        public int VariationID { get; set; }
        public Nullable<int> ProductID { get; set; }
        public string ColorCode { get; set; }
        public string Color1 { get; set; }
        public string Color2 { get; set; }
        public string size { get; set; }
        public Nullable<double> FrameAWidth { get; set; }
        public Nullable<double> FrameBHeight { get; set; }
        public string FrameED { get; set; }
        public string FrameDBBridger { get; set; }
        public string FrameTempleLegs { get; set; }
        public string FrameTotalWidth { get; set; }
        public string MinPDPositive { get; set; }
        public string MinPDNeg { get; set; }
        public string CreatedDate { get; set; }
        public string SideViewImagePath { get; set; }
        public string SKUNumber { get; set; }
        public int Variationimageid { get; set; }
        public string ImagePath { get; set; }
    }
}