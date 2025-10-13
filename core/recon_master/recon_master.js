import { DigitalFingerprintAnalyzer } from '../forensics/digital_fingerprint_analyzer.js';
import { DigitalIntimidationEngine } from '../vintage_war_room/tactical_feedback/intimidation_engine.js';

export class ReconMaster {
    constructor() {
        this.forensics = new DigitalFingerprintAnalyzer();
        this.intimidation = new DigitalIntimidationEngine();
    }

    async executeAdvancedForensics(phoneNumber, foundData) {
        console.log('🎖️ EXECUTING ADVANCED DIGITAL FORENSICS...');
        
        const forensicAnalysis = await this.forensics.analyzeDigitalIdentity(phoneNumber, foundData);
        
        // Activate intimidation protocols based on threat level
        if (forensicAnalysis.threat_level > 0.7) {
            await this.intimidation.activateIntimidationSequence(forensicAnalysis.threat_level);
        }

        return {
            raw_data: foundData,
            forensic_analysis: forensicAnalysis,
            intimidation_applied: forensicAnalysis.threat_level > 0.7,
            final_assessment: this.generateFinalAssessment(forensicAnalysis)
        };
    }

    generateFinalAssessment(analysis) {
        return {
            true_identity_confidence: analysis.identity_confidence,
            vpn_usage_detected: analysis.vpn_detected,
            burner_number_detected: analysis.burner_detected, 
            puppet_network_identified: analysis.puppet_network_detected,
            real_location_estimate: analysis.real_location,
            digital_fingerprint: analysis.digital_fingerprint,
            recommendation: this.generateActionRecommendation(analysis)
        };
    }
}
