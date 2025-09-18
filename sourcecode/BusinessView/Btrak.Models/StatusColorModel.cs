using System;

namespace Btrak.Models
{
    public class StatusColorModel
    {
        public string ColorCode { get; set; }
        public string ColorDescription { get; set; }
    }

    public class ColorCodeModel
    {
        public Guid Id { get; set; }
        public string StatusName { get; set; }
        public string HexaValue { get; set; }
    }
}