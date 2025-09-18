
using System;

namespace BTrak.Common
{
    /// <summary>
    /// Conversion Helper
    /// </summary>
    public class ConversionHelper
    {
        /// <summary>
        /// Converts to boolean.
        /// </summary>
        /// <param name="s">The s.</param>
        /// <returns>Convert to boolean</returns>
        public static bool ConvertToBool(string s)
        {
            bool bitReturn;

            if (bool.TryParse(s, out bitReturn))
            {
                return bitReturn;
            }

            return false;
        }

        /// <summary>
        /// Converts to date time.
        /// </summary>
        /// <param name="s">The s.</param>
        /// <returns>Convert to date time</returns>
        public static DateTime? ConvertToDateTime(string s)
        {
            if (string.IsNullOrWhiteSpace(s))
            {
                return null;
            }

            DateTime dateTimeReturn;

            if (DateTime.TryParse(s, out dateTimeReturn))
            {
                return dateTimeReturn;
            }

            return null;
        }

        /// <summary>
        /// Converts to decimal.
        /// </summary>
        /// <param name="s">The s.</param>
        /// <returns>Convert to decimal</returns>
        public static decimal ConvertToDecimal(string s)
        {
            decimal decimalReturn;

            if (decimal.TryParse(s, out decimalReturn))
            {
                return decimalReturn;
            }

            return 0;
        }

        /// <summary>
        /// Converts to double.
        /// </summary>
        /// <param name="productStandardPrice">The product standard price.</param>
        /// <returns>Convert to double</returns>
        public static double? ConvertToDouble(decimal? productStandardPrice)
        {
            if (productStandardPrice == null)
            {
                return null;
            }

            return Convert.ToDouble(productStandardPrice);
        }

        /// <summary>
        /// Converts to integer.
        /// </summary>
        /// <param name="s">The s.</param>
        /// <returns>Convert To integer</returns>
        public static int ConvertToInt32(string s)
        {
            int intReturn;

            if (int.TryParse(s, out intReturn))
            {
                return intReturn;
            }

            return 0;
        }

        /// <summary>
        /// Converts to not null able date time.
        /// </summary>
        /// <param name="s">The s.</param>
        /// <returns>Convert to Not null able date time</returns>
        public static DateTime ConvertToNotNullableDateTime(string s)
        {
            if (string.IsNullOrWhiteSpace(s))
            {
                return DateTime.MinValue;
            }

            DateTime dateTimeReturn;

            if (DateTime.TryParse(s, out dateTimeReturn))
            {
                return dateTimeReturn;
            }

            return DateTime.MinValue;
        }

        /// <summary>
        /// Converts to null able integer.
        /// </summary>
        /// <param name="s">The s.</param>
        /// <returns>Convert to null able integer</returns>
        public static int? ConvertToNullableInt32(string s)
        {
            int intReturn;

            if (int.TryParse(s, out intReturn))
            {
                return intReturn;
            }

            return null;
        }
    }
}
