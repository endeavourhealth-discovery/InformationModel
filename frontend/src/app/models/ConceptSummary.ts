import {DbEntity} from './DbEntity';
import {ConceptStatus} from './ConceptStatus';
import {Concept} from './Concept';

export class ConceptSummary extends DbEntity {
  context: string;
  fullName: string;
  status: string;
  version: string = "0.1";

  constructor(concept?: Concept) {
    super();

    if (concept) {
      this.id = concept.id;
      this.context = concept.context;
      this.fullName = concept.fullName;
      this.version = concept.version;
    }
  }

}
