using BTrak.Common;
using System;

namespace Btrak.Models.GrERomande
{
    public class GrERomandeSearchInputModel 
    {
        
        public Guid? Id { get; set; }
        public string FileUrl { get; set; }
        public string SearchText { get; set; }
    }
}
