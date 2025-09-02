# Timeline (current → noncurrent → archival)

## Day 0–30
- **Class:** STANDARD  
- **Notes:** normal hot storage.

## Day 30–60
- **Rule:** transition → STANDARD_IA  
- **Class:** STANDARD_IA  
- **Billing:** STANDARD_IA has 30-day minimum → satisfied (30→60 = 30 days).

## Day 60–150
- **Rule:** transition → GLACIER_IR  
- **Class:** GLACIER_IR (Glacier Instant Retrieval)  
- **Billing:** GLACIER_IR has 90-day minimum → satisfied by 60→150 (90 days).

## Day 150
- **Rule:** expiration (current)  
- **Action:** Delete marker is added.  
- **Result:** The object becomes noncurrent (still stored in GLACIER_IR).  
- **Note:** The key now appears “deleted” unless you request by version ID.

## Day 180 (= 150 + noncurrent_days 30)
- **Rule:** noncurrent_version_transition → GLACIER  
- **Class:** GLACIER Flexible Retrieval (noncurrent version moves from IR → GLACIER).  
- **Billing check:** It spent Day 60→180 in IR (120 days) ≥ 90-day min 

## Day 270 (= 150 + noncurrent_days 120)
- **Rule:** noncurrent_version_transition → DEEP_ARCHIVE  
- **Class:** GLACIER DEEP ARCHIVE (colder archive).  
- **Billing check:** It spent Day 180→270 in GLACIER (90 days) ≥ 90-day min 

## Day 515 (= 150 + noncurrent_version_expiration 365)
- **Rule:** noncurrent_version_expiration  
- **Action:** Permanent delete of the noncurrent version in DEEP_ARCHIVE.  
- **Billing check:** It spent Day 270→515 in DEEP_ARCHIVE (245 days) ≥ 180-day min 