//+------------------------------------------------------------------+
//|                                                        Price.mqh |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+
#property strict


#ifndef _LOAD_MODULE_PRICE
#define _LOAD_MODULE_PRICE


/** Include header files. */
#include <mql4_modules\Assert\Assert.mqh>
#include <mql4_modules\Env\Env.mqh>


/** Processing related to price operation. */
class Price
{
   private:
      static int scale;
      
      static void Initialize();

   public:
      static int    getScale(void);
      static bool   setScale(const int value);
      
      static int    PipsToPoint(const double pips_value);
      static double PipsToPrice(const double pips_value);
      static double PointToPips(const int point_value);
      static double PointToPrice(const int point_value);
      static double PriceToPips(const double price_value);
      static int    PriceToPoint(const double price_value);
};


/** @var int scale  scale of point and pips. */
int Price::scale = -1;


/** Initialize the value of the member variable scale. */
static void Price::Initialize(void)
{
   Price::scale = (__Digits == 3 || __Digits == 5) ? 10 : 1;
   
   if (AccountCompany() == "EZ Invest Securities Co., Ltd." &&
       StringSubstr(_Symbol, 0, 6) == "USDJPY") {
      Price::scale = 100;    
   }
}


/**
 * Get the value of the member variable scale.
 *
 * @return int  The value of 'scale'.
 */
static int Price::getScale(void)
{
   return(Price::scale);
}


/**
 * Change the value of the member variable scale.
 *
 * @param const int value  New scale value.
 *
 * @return bool  Returns true if successful, otherwise false.
 */
static bool Price::setScale(const int value)
{
   if(value < 1) return(false);
   Price::scale = value;
   return(true);
}


/**
 * Convert pips unit value to point unit value.
 *
 * @param const double pips_value  Value before conversion. [pips]
 *
 * @return double  Value after conversion. [point]
 */
static int Price::PipsToPoint(const double pips_value)
{
   if(Price::scale < 0) Price::Initialize();
   #ifdef IS_DEBUG
      Price::Initialize();
   #endif
   
   return((int)NormalizeDouble(pips_value * Price::scale, 0));
}


/**
 * Convert pips unit value to price unit value.
 *
 * @param const double pips_value  Value before conversion. [pips]
 *
 * @return double  Value after conversion. 
 */
static double Price::PipsToPrice(const double pips_value)
{
   if(Price::scale < 0) Price::Initialize();
   #ifdef IS_DEBUG
      Price::Initialize();
   #endif
   
   return(pips_value * __Point * Price::scale);
}


/**
 * Convert point unit value to pips unit value.
 *
 * @param const double point_value  Value before conversion. [point]
 *
 * @return double  Value after conversion. [pips]
 */
static double Price::PointToPips(const int point_value)
{
   assert(point_value >= 0, "invalid parameter point_value");
   
   if(Price::scale < 0) Price::Initialize();
   #ifdef IS_DEBUG
      Price::Initialize();
   #endif
   
   return(point_value / Price::scale);
}


/**
 * Convert point unit value to price unit value.
 *
 * @param const double point_value  Value before conversion. [point]
 *
 * @return double  Value after conversion.
 */
static double Price::PointToPrice(const int point_value)
{
   assert(point_value >= 0, "invalid parameter point_value");
   
   return(point_value * __Point);
}


/**
 * Convert price unit value to pips unit value.
 *
 * @param const double price_value  Value before conversion.
 *
 * @return double  Value after conversion. [pips]
 */
static double Price::PriceToPips(const double price_value)
{
   assert(price_value > 0, "invalid parameter price_value");
   
   if(Price::scale < 0) Price::Initialize();
   #ifdef IS_DEBUG
      Price::Initialize();
   #endif

   return(price_value / __Point / Price::scale);
}


/**
 * Convert price unit value to point unit value.
 *
 * @param const double price_value  Value before conversion.
 *
 * @return double  Value after conversion. [point]
 */
static int Price::PriceToPoint(const double price_value)
{
   assert(price_value > 0, "invalid parameter price_value");
   
   return((int)NormalizeDouble(price_value / __Point, 0));
}


#endif 
