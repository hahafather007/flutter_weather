package com.hahafather007.flutterweather.model.data

data class LocationData(val address: String,
                        val country: String,
                        val city: String,
                        val street: String,
                        val longitude: Double,//经度
                        val latitude: Double//纬度
)