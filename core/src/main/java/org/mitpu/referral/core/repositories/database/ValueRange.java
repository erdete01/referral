package org.mitpu.referral.core.repositories.database;

public class ValueRange {

    public int maxValue;

    public int minValue;

    public ValueRange(int minValue, int maxValue) {
        this.maxValue = maxValue;
        this.minValue = minValue;
    }
}
