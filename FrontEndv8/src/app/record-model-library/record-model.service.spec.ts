import { TestBed } from '@angular/core/testing';

import { RecordModelService } from './record-model.service';

describe('RecordModelService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: RecordModelService = TestBed.get(RecordModelService);
    expect(service).toBeTruthy();
  });
});
