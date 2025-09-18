﻿// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Crop.cs" company="James Jackson-South">
//   Copyright (c) James Jackson-South.
//   Licensed under the Apache License, Version 2.0.
// </copyright>
// <summary>
//   Crops an image to the given directions.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace ImageProcessor.Processors
{
    using System;
    using System.Collections.Generic;
    using System.Drawing;
    using System.Drawing.Drawing2D;
    using System.Drawing.Imaging;
    using System.Linq;

    using ImageProcessor.Common.Exceptions;
    using ImageProcessor.Imaging;
    using ImageProcessor.Imaging.Helpers;
    using ImageProcessor.Imaging.MetaData;

    /// <summary>
    /// Crops an image to the given directions.
    /// </summary>
    public class Crop : IGraphicsProcessor
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="Crop"/> class.
        /// </summary>
        public Crop()
        {
            this.Settings = new Dictionary<string, string>();
        }

        /// <summary>
        /// Gets or sets DynamicParameter.
        /// </summary>
        public dynamic DynamicParameter
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets any additional settings required by the processor.
        /// </summary>
        public Dictionary<string, string> Settings
        {
            get;
            set;
        }

        /// <summary>
        /// Processes the image.
        /// </summary>
        /// <param name="factory">
        /// The current instance of the <see cref="T:ImageProcessor.ImageFactory"/> class containing
        /// the image to process.
        /// </param>
        /// <returns>
        /// The processed image from the current instance of the <see cref="T:ImageProcessor.ImageFactory"/> class.
        /// </returns>
        public Image ProcessImage(ImageFactory factory)
        {
            Bitmap newImage = null;
            Image image = factory.Image;
            try
            {
                int sourceWidth = image.Width;
                int sourceHeight = image.Height;
                RectangleF rectangleF;
                CropLayer cropLayer = this.DynamicParameter;

                if (cropLayer.CropMode == CropMode.Percentage)
                {
                    // Fix for whole numbers. 
                    float percentageLeft = cropLayer.Left > 1 ? cropLayer.Left / 100 : cropLayer.Left;
                    float percentageRight = cropLayer.Right > 1 ? cropLayer.Right / 100 : cropLayer.Right;
                    float percentageTop = cropLayer.Top > 1 ? cropLayer.Top / 100 : cropLayer.Top;
                    float percentageBottom = cropLayer.Bottom > 1 ? cropLayer.Bottom / 100 : cropLayer.Bottom;

                    // Work out the percentages.
                    float left = percentageLeft * sourceWidth;
                    float top = percentageTop * sourceHeight;
                    float width = percentageRight < 1 ? (1 - percentageLeft - percentageRight) * sourceWidth : sourceWidth;
                    float height = percentageBottom < 1 ? (1 - percentageTop - percentageBottom) * sourceHeight : sourceHeight;

                    rectangleF = new RectangleF(left, top, width, height);
                }
                else
                {
                    rectangleF = new RectangleF(cropLayer.Left, cropLayer.Top, cropLayer.Right, cropLayer.Bottom);
                }

                Rectangle rectangle = Rectangle.Round(rectangleF);

                if (rectangle.X < sourceWidth && rectangle.Y < sourceHeight)
                {
                    if (rectangle.Width > (sourceWidth - rectangle.X))
                    {
                        rectangle.Width = sourceWidth - rectangle.X;
                    }

                    if (rectangle.Height > (sourceHeight - rectangle.Y))
                    {
                        rectangle.Height = sourceHeight - rectangle.Y;
                    }

                    newImage = new Bitmap(rectangle.Width, rectangle.Height, PixelFormat.Format32bppPArgb);
                    newImage.SetResolution(image.HorizontalResolution, image.VerticalResolution);

                    using (Graphics graphics = Graphics.FromImage(newImage))
                    {
                        GraphicsHelper.SetGraphicsOptions(graphics);

                        // An unwanted border appears when using InterpolationMode.HighQualityBicubic to resize the image
                        // as the algorithm appears to be pulling averaging detail from surrounding pixels beyond the edge 
                        // of the image. Using the ImageAttributes class to specify that the pixels beyond are simply mirror 
                        // images of the pixels within solves this problem.
                        using (ImageAttributes wrapMode = new ImageAttributes())
                        {
                            wrapMode.SetWrapMode(WrapMode.TileFlipXY);
                            graphics.DrawImage(
                                image,
                                new Rectangle(0, 0, rectangle.Width, rectangle.Height),
                                rectangle.X,
                                rectangle.Y,
                                rectangle.Width,
                                rectangle.Height,
                                GraphicsUnit.Pixel,
                                wrapMode);
                        }
                    }

                    // Reassign the image.
                    image.Dispose();
                    image = newImage;

                    if (factory.PreserveExifData && factory.ExifPropertyItems.Any())
                    {
                        // Set the width EXIF data.
                        factory.SetPropertyItem(ExifPropertyTag.ImageWidth, (ushort)image.Width);

                        // Set the height EXIF data.
                        factory.SetPropertyItem(ExifPropertyTag.ImageHeight, (ushort)image.Height);
                    }
                }
            }
            catch (Exception exception)
            {
                newImage?.Dispose();

                throw new ImageProcessingException("Error processing image with " + this.GetType().Name, exception);
            }

            return image;
        }
    }
}
